page 50068 "Item No-Moving"
{
    Caption = 'Item Ledger Entries';
    DataCaptionExpression = GetCaption;
    DataCaptionFields = "Item No.";
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING("Item No.")
                      WHERE("Entry Type" = CONST(Purchase));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    Visible = true;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Visible = true;
                }
                field("Shipped Qty. Not Returned"; Rec."Shipped Qty. Not Returned")
                {
                    Visible = false;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    Visible = false;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    Visible = false;
                }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)")
                {
                    Visible = false;
                }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)")
                {
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    Visible = false;
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)")
                {
                }
                field("Cost Amount (Expected) (ACY)"; Rec."Cost Amount (Expected) (ACY)")
                {
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; Rec."Cost Amount (Actual) (ACY)")
                {
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)")
                {
                    Visible = false;
                }
                field("Completely Invoiced"; Rec."Completely Invoiced")
                {
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    Visible = false;
                }
                field("Applied Entry to Adjust"; Rec."Applied Entry to Adjust")
                {
                    Visible = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Visible = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    Visible = false;
                }
                field("Prod. Order Comp. Line No."; Rec."Prod. Order Comp. Line No.")
                {
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    //<<200
                    // RunPageLink = "Table ID" = CONST(32),
                    //               "Entry No." = FIELD("Entry No.");
                    // RunObject = Page "Ledger Entry Dimensions";
                    // ShortCutKey = 'Shift+Ctrl+D';
                    //>>
                }
                action("&Value Entries")
                {
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunPageLink = "Item Ledger Entry No." = FIELD("Entry No.");
                    RunPageView = SORTING("Item Ledger Entry No.");
                    RunObject = Page "Value Entries";
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("&Application")
            {
                Caption = '&Application';
                action("Applied E&ntries")
                {
                    Caption = 'Applied E&ntries';

                    trigger OnAction()
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Show Applied Entries", Rec);
                    end;
                }
                action("Reservation Entries")
                {
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowReservationEntries(TRUE);
                    end;
                }
                action("Application Worksheet")
                {
                    Caption = 'Application Worksheet';

                    trigger OnAction()
                    var
                        Worksheet: Page "Application Worksheet";
                    begin
                        CLEAR(Worksheet);
                        Worksheet.SetRecordToShow(Rec);
                        Worksheet.RUN();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Order &Tracking")
                {
                    Caption = 'Order &Tracking';

                    trigger OnAction()
                    var
                        TrackingForm: Page "Order Tracking";
                    begin
                        TrackingForm.SetItemLedgEntry(Rec);
                        TrackingForm.RUNMODAL;
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        TotalRow := Rec.COUNT;
        CurRow := 0;
        Window.OPEN('Calculating\' +
                    '@@@@1@@@@@@@@@@@@@@@@@');
        Window.UPDATE(1, 0);
        IF Rec.FIND('-') THEN
            REPEAT
                IF Rec."Remaining Quantity" = Rec.Quantity THEN
                    Rec.MARK(TRUE);
                CurRow := CurRow + 1;
                Window.UPDATE(1, ROUND(CurRow / TotalRow * 10000, 1))
            UNTIL Rec.NEXT = 0;
        Rec.MARKEDONLY(TRUE);
        Window.CLOSE;
    end;

    var
        Navigate: Page "Navigate";
        Window: Dialog;
        TotalRow: Integer;
        CurRow: Integer;

    procedure GetCaption(): Text[250]
    var
        GLSetup: Record "General Ledger Setup";
        ObjTransl: Record "Object Translation";
        Item: Record "Item";
        ProdOrder: Record "Production Order";
        Cust: Record "Customer";
        Vend: Record "Vendor";
        Dimension: Record "Dimension";
        DimValue: Record "Dimension Value";
        SourceTableName: Text[100];
        SourceFilter: Text[200];
        Description: Text[100];
    begin
        Description := '';

        CASE TRUE OF
            Rec.GETFILTER("Item No.") <> '':
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);
                    SourceFilter := Rec.GETFILTER("Item No.");
                    IF MAXSTRLEN(Item."No.") >= STRLEN(SourceFilter) THEN
                        IF Item.GET(SourceFilter) THEN
                            Description := Item.Description;
                END;
            Rec.GETFILTER("Prod. Order No.") <> '':
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5405);
                    SourceFilter := Rec.GETFILTER("Prod. Order No.");
                    IF MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter) THEN
                        IF ProdOrder.GET(ProdOrder.Status::Released, SourceFilter) OR
                           ProdOrder.GET(ProdOrder.Status::Finished, SourceFilter)
                        THEN BEGIN
                            SourceTableName := STRSUBSTNO('%1 %2', ProdOrder.Status, SourceTableName);
                            Description := ProdOrder.Description;
                        END;
                END;
            Rec.GETFILTER("Source No.") <> '':
                BEGIN
                    CASE Rec."Source Type" OF
                        Rec."Source Type"::Customer:
                            BEGIN
                                SourceTableName :=
                                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                                SourceFilter := Rec.GETFILTER("Source No.");
                                IF MAXSTRLEN(Cust."No.") >= STRLEN(SourceFilter) THEN
                                    IF Cust.GET(SourceFilter) THEN
                                        Description := Cust.Name;
                            END;
                        Rec."Source Type"::Vendor:
                            BEGIN
                                SourceTableName :=
                                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 23);
                                SourceFilter := Rec.GETFILTER("Source No.");
                                IF MAXSTRLEN(Vend."No.") >= STRLEN(SourceFilter) THEN
                                    IF Vend.GET(SourceFilter) THEN
                                        Description := Vend.Name;
                            END;
                    END;
                END;
            Rec.GETFILTER("Global Dimension 1 Code") <> '':
                BEGIN
                    GLSetup.GET;
                    Dimension.Code := GLSetup."Global Dimension 1 Code";
                    SourceFilter := Rec.GETFILTER("Global Dimension 1 Code");
                    SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
                    IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
                        IF DimValue.GET(GLSetup."Global Dimension 1 Code", SourceFilter) THEN
                            Description := DimValue.Name;
                END;
            Rec.GETFILTER("Global Dimension 2 Code") <> '':
                BEGIN
                    GLSetup.GET;
                    Dimension.Code := GLSetup."Global Dimension 2 Code";
                    SourceFilter := Rec.GETFILTER("Global Dimension 2 Code");
                    SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
                    IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
                        IF DimValue.GET(GLSetup."Global Dimension 2 Code", SourceFilter) THEN
                            Description := DimValue.Name;
                END;
            Rec.GETFILTER("Document Type") <> '':
                BEGIN
                    SourceTableName := Rec.GETFILTER("Document Type");
                    SourceFilter := Rec.GETFILTER("Document No.");
                    Description := Rec.GETFILTER("Document Line No.");
                END;
        END;
        EXIT(STRSUBSTNO('%1 %2 %3', SourceTableName, SourceFilter, Description));
    end;
}

