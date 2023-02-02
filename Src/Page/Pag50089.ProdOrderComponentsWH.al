page 50089 "Prod. Order Components-WH"
{
    AutoSplitKey = true;
    Caption = 'Prod. Order Components';
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                // field(ShortcutDimCode[3];ShortcutDimCode[3])
                // {
                //     CaptionClass = '1,2,3';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(3,ShortcutDimCode[3]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                //     end;
                // }
                // field(ShortcutDimCode[4];ShortcutDimCode[4])
                // {
                //     CaptionClass = '1,2,4';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(4,ShortcutDimCode[4]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                //     end;
                // }
                // field(ShortcutDimCode[5];ShortcutDimCode[5])
                // {
                //     CaptionClass = '1,2,5';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(5,ShortcutDimCode[5]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                //     end;
                // }
                // field(ShortcutDimCode[6];ShortcutDimCode[6])
                // {
                //     CaptionClass = '1,2,6';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(6,ShortcutDimCode[6]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                //     end;
                // }
                // field(ShortcutDimCode[7];ShortcutDimCode[7])
                // {
                //     CaptionClass = '1,2,7';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(7,ShortcutDimCode[7]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                //     end;
                // }
                // field(ShortcutDimCode[8];ShortcutDimCode[8])
                // {
                //     CaptionClass = '1,2,8';
                //     Visible = false;

                //     trigger OnLookup(var Text: Text): Boolean
                //     begin
                //         LookupShortcutDimCode(8,ShortcutDimCode[8]);
                //     end;

                //     trigger OnValidate()
                //     begin
                //         ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                //     end;
                // }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Visible = false;
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    Visible = false;
                }
                field(Position; Rec.Position)
                {
                    Visible = false;
                }
                field("Position 2"; Rec."Position 2")
                {
                    Visible = false;
                }
                field("Position 3"; Rec."Position 3")
                {
                    Visible = false;
                }
                field("Lead-Time Offset"; Rec."Lead-Time Offset")
                {
                    Visible = false;
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                }
                field("Qty. Picked (Base)"; Rec."Qty. Picked (Base)")
                {
                    Visible = false;
                }
                field("Act. Consumption (Qty)"; Rec."Act. Consumption (Qty)")
                {
                }
                field("Substitution Available"; Rec."Substitution Available")
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
            action("Replace With New Item")
            {
                Caption = 'Replace With New Item';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderBOM: Record "Prod. Order Component";
                    ECNRecord: Record "ECN Record";
                    ProdOrderBOM2: Record "Prod. Order Component" temporary;
                    LineNo: Integer;
                begin
                    if Confirm(Text001) then begin
                        CurrPage.SetSelectionFilter(ProdOrderBOM);
                        if ProdOrderBOM.FindFirst() then
                            repeat
                                LineNo := ProdOrderBOM."Line No.";
                                if ProdOrderBOM."Item No." = OldItemNo then begin
                                    // ProdOrderBOM.Validate("Item No.", NewItemNo);
                                    // ProdOrderBOM.Modify();
                                    //删除历史数据
                                    ProdOrderBOM.Delete;
                                    //创建新数据
                                    ECNRecord.Reset();
                                    ECNRecord.SetRange("Item No.", OldItemNo);
                                    if ECNRecord.FindFirst() then
                                        repeat
                                            LineNo += 10000;
                                            ProdOrderBOM2.Init;
                                            ProdOrderBOM2.Copy(ProdOrderBOM);
                                            ProdOrderBOM2."Line No." := LineNo;
                                            ProdOrderBOM2.Quantity := ECNRecord."New Quantity";
                                            ProdOrderBOM2.Insert;
                                        until ECNRecord.Next() = 0;
                                end else
                                    Error(Text002);
                            until ProdOrderBOM.Next() = 0;
                    end;
                end;
            }
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

    procedure SetValue(OldItemNoP: Code[20]; NewItemNo: Code[20])
    begin
        OldItemNo := OldItemNoP;
        NewItemNo := NewItemNo;
    end;

    var
        Text000: Label 'You cannot reserve components with status %1.';
        ShortcutDimCode: array[8] of Code[20];
        OldItemNo: Code[20];
        NewItemNo: Code[20];
        Text001: Label 'Will you confirm to replace the selected component lines!';
        Text002: Label 'The selected item is incorrect.';

}