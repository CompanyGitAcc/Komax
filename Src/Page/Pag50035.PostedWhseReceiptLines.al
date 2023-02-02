page 50035 "MP Whse. Receipt Lines"
{
    Caption = 'Warehouse Receipt Lines';
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Posted Whse. Receipt Line";
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
                        WhseReceiptPage: Page "Posted Whse. Receipt";
                    begin
                        WhseReceiptHeader.SetRange("No.", Rec."No.");
                        WhseReceiptPage.SetTableView(WhseReceiptHeader);
                        WhseReceiptPage.RunModal();
                    end;
                }
                field("Whse. Receipt No."; Rec."Whse. Receipt No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(OrderStatus; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
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
                field(BuyFromVendorName; BuyFromVendorName)
                {
                    Caption = 'BuyFromVendorName';
                    ApplicationArea = Basic, Suite;
                }
                field(PurchaserCode; PurchaserCode)
                {
                    Caption = 'PurchaserCode';
                    ApplicationArea = Basic, Suite;
                }
                field(Purchaser; Purchaser)
                {
                    Caption = 'Purchaser';
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
                        WhseReceiptHeader.Get(Rec."Document Type", Rec."Document No.");
                        PageManagement.PageRun(WhseReceiptHeader);
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
        WhseReceiptHeader: Record "Purchase Header";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        TmpPostedWhseReceiptHeader: Record "Posted Whse. Receipt Header" temporary;
        LineCount: Integer;
        OrderCount: Integer;
    begin
        // if PurchaseLine.get(PurchaseLine."Document Type"::Order, Rec."Source No.", Rec."Source Line No.") then begin
        //     BuyFromVendorName := PurchaseLine."Buy-from Vendor Name";
        // end else
        //     BuyFromVendorName := '';

        if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, Rec."Source No.") then begin
            PurchaserCode := PurchaseHeader."Purchaser Code";
            BuyFromVendorName := PurchaseHeader."Buy-from Vendor Name";
            if SalespersonPurchaser.get(PurchaseHeader."Purchaser Code") then begin
                Purchaser := SalespersonPurchaser.Name;
            end else
                Purchaser := '';
        end else begin
            PurchaserCode := '';
            Purchaser := '';
            BuyFromVendorName := '';
        end;
        //Calc total Line count
        LineCount := 0;
        PostedWhseReceiptLine.CopyFilters(Rec);
        if PostedWhseReceiptLine.FindFirst() then
            repeat
                LineCount += 1;
                TmpPostedWhseReceiptHeader.init();
                TmpPostedWhseReceiptHeader."No." := PostedWhseReceiptLine."No.";
                if TmpPostedWhseReceiptHeader.Insert() then;
            until PostedWhseReceiptLine.Next() = 0;

        TmpPostedWhseReceiptHeader.Reset();
        if TmpPostedWhseReceiptHeader.FindFirst() then
            repeat
                OrderCount += 1;
            until TmpPostedWhseReceiptHeader.Next() = 0;
        TotalLineCount := '单据数：' + Format(OrderCount) + '  行数：' + Format(LineCount);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        WhseReceiptHeader: record "Posted Whse. Receipt Header";
        PurchaseLine: Record "Purchase Line";
        BuyFromVendorName: Text[100];
        PurchaseHeader: Record "Purchase Header";
        PurchaserCode: Code[20];
        Purchaser: Text[100];
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    // OrderDate: date;
    // Purchaser: Code[20];

    protected var
        ShortcutDimCode: array[8] of Code[20];
        TotalLineCount: Text;
}


