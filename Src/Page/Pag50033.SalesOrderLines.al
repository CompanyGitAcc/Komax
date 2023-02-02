page 50033 "TP Sales Lines"
{
    Caption = 'Sales Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = sorting("Document No.") order(descending) where("Document Type" = const("Order"), type = filter(<> ''));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown()
                    var
                        SalesOrderPage: Page "Sales Order";
                    begin
                        SalesHeader.SetRange("Document Type", Rec."Document Type");
                        SalesHeader.SetRange("No.", Rec."Document No.");
                        SalesOrderPage.SetTableView(SalesHeader);
                        SalesOrderPage.RunModal();
                    end;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }

                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                //--TP02-PR
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                    ApplicationArea = Basic, Suite;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = all;
                }
                field(Department; Department)
                {
                    Caption = 'Department';
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic, Suite;
                }
                //期初
                // field("Post Qty"; Rec."Post Qty")
                // {
                //     ApplicationArea = Basic, Suite;
                // }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    ApplicationArea = Basic, Suite;
                    // CaptionClass = 'Unit Price';
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    // CaptionClass = 'Line Amount';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posted Sales Inv. No."; Rec."Posted Sales Inv. No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }

            // field(TotalLineCount; TotalLineCount)
            // {
            //     Caption = 'Total Lines';
            //     ShowCaption = false;
            //     ApplicationArea = Basic, Suite;
            // }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;

            }

            Group(Function)
            {
                Caption = 'Function';

            }
        }
    }


    trigger OnAfterGetRecord()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        DimensionValue: Record "Dimension Value";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        TmpSalesHeader: Record "Sales Header" temporary;
        LineCount: Integer;
        OrderCount: Integer;
    begin
        // Rec.ShowShortcutDimCode(ShortcutDimCode);

        // SalesHeader.Reset();
        // if SalesHeader.get(Rec."Document Type"::Order, Rec."Document No.") then begin
        //     if SalespersonPurchaser.get(SalesHeader."Salesperson Code") then begin
        //         "SalespersonName" := SalespersonPurchaser.Name;
        //     end else
        //         "SalespersonName" := '';
        // end;

        // if DimensionValue.get('Department', Rec."Shortcut Dimension 1 Code") then begin
        //     Department := DimensionValue.Name;
        // end else
        //     Department := '';

        //Calc total Line count
        // LineCount := 0;
        // SalesLine.CopyFilters(Rec);
        // if SalesLine.FindFirst() then
        //     repeat
        //         LineCount += 1;
        //         TmpSalesHeader.init();
        //         TmpSalesHeader."Document Type" := SalesLine."Document Type";
        //         TmpSalesHeader."No." := SalesLine."Document No.";
        //         if TmpSalesHeader.Insert() then;
        //     until SalesLine.Next() = 0;

        // TmpSalesHeader.Reset();
        // if TmpSalesHeader.FindFirst() then
        //     repeat
        //         OrderCount += 1;
        //     until TmpSalesHeader.Next() = 0;
        // TotalLineCount := '单据数：' + Format(OrderCount) + '  行数：' + Format(LineCount);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        SalesHeader: Record "Sales Header";
        SalespersonName: Text[100];
        Department: Text[100];
        DimensionValue: Record "Dimension Value";

    protected var
        ShortcutDimCode: array[8] of Code[20];
    // TotalLineCount: Text;
}


