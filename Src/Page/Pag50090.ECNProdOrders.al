page 50090 "ECN Prod. Orders"
{
    AutoSplitKey = true;
    Caption = 'ECN Production Orders';
    DelayedInsert = true;
    Editable = false;
    //MultipleNewLines = true;
    PageType = List;
    SourceTable = "Prod. Order Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field(Description; Rec.Description)
                {
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }


                field("Location Code"; Rec."Location Code")
                {
                    Visible = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }

            }
        }

    }

    actions
    {
        area(navigation)
        {

        }
        area(processing)
        {
            action("Open Document")
            {
                Caption = 'Open Document';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ReleasedProductionOrder: Page "Released Production Order";
                    ProductionOrder: Record "Production Order";
                begin
                    ProductionOrder.SetRange("No.", Rec."Prod. Order No.");
                    ReleasedProductionOrder.SetTableView(ProductionOrder);
                    ReleasedProductionOrder.RunModal();
                end;
            }

            action("Process ECN")
            {
                Caption = 'Process ECN';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderLine: Record "Prod. Order Line";
                    ProdOrderBOM: Record "Prod. Order Component";
                    ECNRecord: Record "ECN Record";
                    ProdOrderBOM2: Record "Prod. Order Component" temporary;
                    LineNo: Integer;
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                    ItemFilterString: Text[100];
                    ECNItemCount: Integer;
                    LastItemNo: Code[20];
                    FirstComponentItemQty: Decimal;
                    LastLineNo: Integer;
                    FirstComponentItemBin: Code[20];
                begin
                    if not Confirm(Text001) then
                        exit;
                    FirstComponentItemBin := '';
                    ECNRecord.Reset();
                    ECNRecord.SetRange("No.", ECNNo);
                    if ECNRecord.FindFirst() then begin
                        ECNItemCount := ECNRecord.Count;
                        repeat
                            if ECNRecord."Substitute Type" = ECNRecord."Substitute Type"::"1:N" then begin
                                ItemFilterString := ECNRecord."Item No.";
                                // if LastItemNo <> ECNRecord."Item No." then
                                //     Error('%1 is not a correct 1:N ECN record, please check.', ECNRecord."No.");
                            end;
                            if ECNRecord."Substitute Type" = ECNRecord."Substitute Type"::"N:1" then begin
                                if ItemFilterString = '' then
                                    ItemFilterString := ECNRecord."Item No."
                                else
                                    ItemFilterString := ItemFilterString + '|' + ECNRecord."Item No.";
                            end;
                            LastItemNo := ECNRecord."Item No.";
                        until ECNRecord.Next() = 0;
                    end;

                    CurrPage.SetSelectionFilter(ProdOrderLine);
                    If ProdOrderLine.FindFirst() then
                        repeat
                            ProdOrderBOM.Reset();
                            ProdOrderBOM.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                            ProdOrderBOM.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                            ProdOrderBOM.SetFilter("Item No.", ItemFilterString);
                            if ProdOrderBOM.FindFirst() then begin
                                FirstComponentItemQty := ProdOrderBOM.Quantity;
                                FirstComponentItemBin := ProdOrderBOM."Bin Code";
                                if ProdOrderBOM.Count <> ECNItemCount then
                                    Error('Item Counts are not matching between prod. order %1 and ECN %2', ProdOrderBOM."Prod. Order No.", ECNRecord."No.");
                                repeat
                                    ProdOrderBOM.Delete();
                                until ProdOrderBOM.Next() = 0;
                            end;
                            ProdOrderBOM2.Reset();
                            ProdOrderBOM2.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                            ProdOrderBOM2.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                            if ProdOrderBOM2.FindFirst() then
                                LastLineNo := ProdOrderBOM2."Line No." + 10000
                            else
                                LastLineNo := 100000;

                            ECNRecord.FindFirst();
                            if ECNRecord."Substitute Type" = ECNRecord."Substitute Type"::"1:N" then begin
                                repeat
                                    ProdOrderBOM2.Init();
                                    ProdOrderBOM2.Status := ProdOrderLine.Status;
                                    ProdOrderBOM2."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                                    ProdOrderBOM2."Prod. Order Line No." := ProdOrderLine."Line No.";
                                    ProdOrderBOM2."Line No." := LastLineNo;
                                    ProdOrderBOM2.Validate("Item No.", ECNRecord."Substitute Item No.");
                                    ProdOrderBOM2.Validate(Quantity, FirstComponentItemQty * ECNRecord."Quantity Per");
                                    ProdOrderBOM2.Validate("Location Code", ProdOrderLine."Location Code");
                                    ProdOrderBOM2.Validate("Bin Code", FirstComponentItemBin);
                                    ProdOrderBOM2.Insert(true);
                                    LastLineNo := LastLineNo + 10000;
                                until ECNRecord.Next() = 0;
                            end;
                            if ECNRecord."Substitute Type" = ECNRecord."Substitute Type"::"N:1" then begin
                                ProdOrderBOM2.Init();
                                ProdOrderBOM2.Status := ProdOrderLine.Status;
                                ProdOrderBOM2."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                                ProdOrderBOM2."Prod. Order Line No." := ProdOrderLine."Line No.";
                                ProdOrderBOM2."Line No." := LastLineNo;
                                ProdOrderBOM2.Validate("Item No.", ECNRecord."Substitute Item No.");
                                ProdOrderBOM2.Validate(Quantity, FirstComponentItemQty * ECNRecord."Quantity Per");
                                ProdOrderBOM2.Validate("Location Code", ProdOrderLine."Location Code");
                                ProdOrderBOM2.Validate("Bin Code", FirstComponentItemBin);
                                ProdOrderBOM2.Insert(true);
                            end
                        until ProdOrderLine.Next() = 0;
                end;
            }

            // action("Replace With New Item")
            // {
            //     Caption = 'Replace With New Item';
            //     Image = Components;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     ApplicationArea = all;

            //     trigger OnAction()
            //     var
            //         ProdOrderBOM: Record "Prod. Order Component";
            //         ECNRecord: Record "ECN Record";
            //         ProdOrderBOM2: Record "Prod. Order Component" temporary;
            //         LineNo: Integer;
            //         WarehouseActivityLine: Record "Warehouse Activity Line";
            //     begin
            //         if Confirm(Text001) then begin
            //             CurrPage.SetSelectionFilter(ProdOrderBOM);
            //             if ProdOrderBOM.FindFirst() then
            //                 repeat
            //                     LineNo := ProdOrderBOM."Line No.";
            //                     if ProdOrderBOM."Item No." = OldItemNo then begin
            //                         WarehouseActivityLine.Reset();
            //                         WarehouseActivityLine.SetFilter("Activity Type", '%1|%2', WarehouseActivityLine."Activity Type"::Pick, WarehouseActivityLine."Activity Type"::Movement);
            //                         WarehouseActivityLine.SetRange("Item No.", Rec."Item No.");
            //                         if WarehouseActivityLine.FindFirst() then begin
            //                             Error(Text003, Rec."Item No.");
            //                         end else begin
            //                             ProdOrderBOM.Validate("Item No.", NewItemNo);
            //                             ProdOrderBOM.Modify();
            //                         end;
            //                         // //删除历史数据
            //                         // ProdOrderBOM.Delete;
            //                         // //创建新数据
            //                         // ECNRecord.Reset();
            //                         // ECNRecord.SetRange("Item No.", OldItemNo);
            //                         // if ECNRecord.FindFirst() then
            //                         //     repeat
            //                         //         LineNo += 10000;
            //                         //         ProdOrderBOM2.Init;
            //                         //         ProdOrderBOM2.Copy(ProdOrderBOM);
            //                         //         ProdOrderBOM2."Line No." := LineNo;
            //                         //         ProdOrderBOM2.Quantity := ECNRecord."New Quantity";
            //                         //         ProdOrderBOM2.Insert;
            //                         //     until ECNRecord.Next() = 0;
            //                     end else
            //                         Error(Text002);
            //                 until ProdOrderBOM.Next() = 0;
            //         end;
            //     end;
            // }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage()
    begin
        IF Rec.FINDFIRST THEN
            ECNNo := Rec."Description 2";
    end;

    procedure SetValue(ECNNoP: Code[20])
    begin
        ECNNo := ECNNoP;
    end;

    var
        Text000: Label 'You cannot reserve components with status %1.';
        ShortcutDimCode: array[8] of Code[20];
        ECNNo: Code[20];
        Text001: Label 'Will you confirm to process the ECN on the selected production order?';
        Text002: Label 'The selected item is incorrect.';
        Text003: Label 'The item No. %1 already exists in Pick or Movement.';

}