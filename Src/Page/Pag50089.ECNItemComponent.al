page 50089 "ECN Item Components"
{
    AutoSplitKey = true;
    Caption = 'ECN Item Components';
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Prod. Order Component";
    SourceTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
                      ORDER(Descending)
                      WHERE(Status = CONST(Released));

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
                // field("Parent Item No."; Rec."Parent Item No.")
                // {
                //     ApplicationArea = all;
                // }
                // field("Product Quantity"; Rec."Product Quantity")
                // {
                // }
                field("Item No."; Rec."Item No.")
                {

                    trigger OnValidate()
                    begin
                        // ItemNoOnAfterValidate;
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field("Due Date-Time"; Rec."Due Date-Time")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                // field("Actual Quantity"; rec."Product Quantity")
                // {
                //     Visible = false;
                // }
                field("Scrap %"; Rec."Scrap %")
                {

                }
                field("Calculation Formula"; Rec."Calculation Formula")
                {
                    Visible = false;

                }
                field("Quantity per"; Rec."Quantity per")
                {
                }
                // field("Original Expected Qty."; Rec."Original Expected Qty. (Base)")
                // {
                // }
                // field("Original Expected Barcodes"; Rec."Original Expected Barcodes")
                // {
                //     Editable = false;
                // }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowReservationEntries(TRUE);
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {

                    trigger OnValidate()
                    begin
                        // UnitofMeasureCodeOnAfterValida;
                    end;
                }
                field("Flushing Method"; Rec."Flushing Method")
                {
                    Visible = false;
                }
                field("Expected Quantity"; Rec."Expected Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
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

                field("Act. Consumption (Qty)"; Rec."Act. Consumption (Qty)")
                {
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
            //Moved to ECN Prod Orders
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
        IF Rec.FINDFIRST THEN;
    end;

    procedure SetValue(OldItemNoP: Code[20]; NewItemNoP: Code[20])
    begin
        OldItemNo := OldItemNoP;
        NewItemNo := NewItemNoP;
    end;

    var
        Text000: Label 'You cannot reserve components with status %1.';
        ShortcutDimCode: array[8] of Code[20];
        OldItemNo: Code[20];
        NewItemNo: Code[20];
        Text001: Label 'Will you confirm to replace the selected component lines!';
        Text002: Label 'The selected item is incorrect.';
        Text003: Label 'The item No. %1 already exists in Pick or Movement.';

}