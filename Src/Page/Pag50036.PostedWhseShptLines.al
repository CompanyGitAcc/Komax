page 50036 "MP Whse. Shipment Lines"
{
    Caption = 'Warehouse Shipment Lines';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Posted Whse. Shipment Line";
    SourceTableView = sorting("Posting Date") order(descending);
    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    trigger OnDrillDown()
                    var
                        WhseShipmentPage: Page "Posted Whse. Shipment";
                    begin
                        WhseShipmentHeader.SetRange("No.", Rec."No.");
                        WhseShipmentPage.SetTableView(WhseShipmentHeader);
                        WhseShipmentPage.RunModal();
                    end;
                }
                field("Whse. Shipment No."; Rec."Whse. Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
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
                    Visible = true;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Location;
                    Visible = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(SellToCustomerNo; SellToCustomerNo)
                {
                    Caption = 'SellToCustomerNo';
                    ApplicationArea = Basic, Suite;
                }
                field(SellToCustomerName; SellToCustomerName)
                {
                    Caption = 'SellToCustomerName';
                    ApplicationArea = Basic, Suite;
                }
                field(DepartmentCode; DepartmentCode)
                {
                    Caption = 'DepartmentCode';
                    ApplicationArea = Basic, Suite;
                }
                field(DepartmentName; DepartmentName)
                {
                    Caption = 'DepartmentName';
                    ApplicationArea = Basic, Suite;
                }
                field(SalespersonCode; SalespersonCode)
                {
                    Caption = 'SalespersonCode';
                    ApplicationArea = Basic, Suite;
                }
                field(SalespersonName; SalespersonName)
                {
                    Caption = 'SalespersonName';
                    ApplicationArea = Basic, Suite;
                }
            }
            field(TotalLineCount; TotalLineCount)
            {
                Caption = 'Total Lines';
                ShowCaption = false;
                ApplicationArea = Basic, Suite;
            }


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
                /*
                action("Show Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageManagement: Codeunit "Page Management";
                    begin
                        WhseShipmentHeader.Get(Rec."Document Type", Rec."Document No.");
                        PageManagement.PageRun(WhseShipmentHeader);
                    end;
                }
                */
                action("Document of Today")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document of Today';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.SetRange("Posting Date", Today);
                    end;
                }
                action("All Documents")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Documents';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Rec.reset();
                    end;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    var
        WhseShipmentHeader: Record "Purchase Header";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        TmpPostedWhseShipmentHeader: Record "Posted Whse. Shipment Header" temporary;
        LineCount: Integer;
        OrderCount: Integer;
    begin

        if SalesLine.get(SalesLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.") then begin
            SellToCustomerNo := SalesLine."Sell-to Customer No.";
            // SellToCustomerName := SalesLine."Sell-to Customer Name";
            DepartmentCode := SalesLine."Shortcut Dimension 1 Code";
            if DimensionValue.get('Department', SalesLine."Shortcut Dimension 1 Code") then begin
                DepartmentName := DimensionValue.Name;
            end else begin
                DepartmentName := '';
            end;
            // SalespersonCode := SalesLine."Salesperson Code";
            // if SalespersonPurchaser.get(SalesLine."Salesperson Code") then begin
            //     SalespersonName := SalespersonPurchaser.Name;
            // end else begin
            //     SalespersonName := '';
            // end;
        end else begin
            SellToCustomerNo := '';
            // SellToCustomerName := '';
            DepartmentCode := '';
            DepartmentName := '';
            // SalespersonCode := '';
            // SalespersonName := '';
        end;

        if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
            SellToCustomerName := SalesHeader."Sell-to Customer Name";
            SalespersonCode := SalesHeader."Salesperson Code";
            if SalespersonPurchaser.get(SalesHeader."Salesperson Code") then begin
                SalespersonName := SalespersonPurchaser.Name;
            end else begin
                SalespersonName := '';
            end;
        end else begin
            SellToCustomerName := '';
            SalespersonCode := '';
            SalespersonName := '';
        end;

        //Calc total Line count
        LineCount := 0;
        PostedWhseShipmentLine.CopyFilters(Rec);
        if PostedWhseShipmentLine.FindFirst() then
            repeat
                LineCount += 1;
                TmpPostedWhseShipmentHeader.init();
                TmpPostedWhseShipmentHeader."No." := PostedWhseShipmentLine."No.";
                if TmpPostedWhseShipmentHeader.Insert() then;
            until PostedWhseShipmentLine.Next() = 0;

        TmpPostedWhseShipmentHeader.Reset();
        if TmpPostedWhseShipmentHeader.FindFirst() then
            repeat
                OrderCount += 1;
            until TmpPostedWhseShipmentHeader.Next() = 0;
        TotalLineCount := '单据数：' + Format(OrderCount) + '  行数：' + Format(LineCount);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        WhseShipmentHeader: record "Posted Whse. Shipment Header";
        SalesLine: Record "Sales Line";
        SellToCustomerNo: Code[20];
        SellToCustomerName: Text[100];
        DepartmentCode: Code[20];
        DepartmentName: Text[100];
        SalespersonCode: Code[20];
        SalespersonName: Text[100];
        DimensionValue: Record "Dimension Value";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        SalesHeader: Record "Sales Header";
    // OrderDate: date;
    // Purchaser: Code[20];

    protected var
        ShortcutDimCode: array[8] of Code[20];
        TotalLineCount: Text;
}


