pageextension 59093 "TP Posted Whse. Receipt List" extends "Posted Whse. Receipt List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }

            field("Buy-from Type"; Rec."Buy-from Type")
            {
                ApplicationArea = ALL;
            }
            field("Buy-from No."; Rec."Buy-from No.")
            {
                ApplicationArea = ALL;
            }
            field(Name; Rec."Buy-from Name")
            {
                ApplicationArea = ALL;
            }
            field("Ship-to Address Code"; Rec."Buy-from Address Code")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field(Address; Rec."Buy-from Address")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field("Phone No."; Rec."Buy-from Phone No.")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field(Contact; Rec."Buy-from Contact")
            {
                Visible = false;
                ApplicationArea = all;
            }

        }
        //--YK004

        modify("Posting Date")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field(TotalQuantity; TotalQuantity)
            {
                Caption = 'TotalQuantity';
                ApplicationArea = all;
            }
            field(TotalAmount2; TotalAmount2)
            {
                Caption = 'TotalAmount2';
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Put-away Lines")
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Batch Post")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Print Selected Warehouse Receipts';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
                        ReportSelectionWhse: Record "Report Selection Warehouse";
                    begin
                        CurrPage.SetSelectionFilter(PostedWhseReceiptHeader);
                        //批量打印采购收货单
                        // PostedWhseReceiptHeader.SetRange("No.", PostedWhseReceiptHeader."No.");
                        ReportSelectionWhse.PrintPostedWhseReceiptHeader(PostedWhseReceiptHeader, false);
                    end;
                }
            }
        }
    }

    var
        WarehouseReceiptLine: Record "Posted Whse. Receipt Line";
        PurchaseLine: Record "Purchase Line";
        TotalQuantity: Integer;
        TotalAmount2: Decimal;
        PrintCount2: Integer;

    trigger OnAfterGetRecord()
    begin
        TotalQuantity := 0;
        TotalAmount2 := 0;
        WarehouseReceiptLine.Reset();
        WarehouseReceiptLine.SetRange("No.", Rec."No.");
        if WarehouseReceiptLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseReceiptLine.Quantity;
                if PurchaseLine.get(PurchaseLine."Document Type"::Order, WarehouseReceiptLine."Source No.", WarehouseReceiptLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseReceiptLine.Quantity * PurchaseLine."Direct Unit Cost";
                end;
            until WarehouseReceiptLine.Next() = 0;
    end;
}
