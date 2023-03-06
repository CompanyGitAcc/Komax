pageextension 59090 "TP Warehouse Receipts" extends "Warehouse Receipts"
{
    layout
    {
        addafter("Location Code")
        {
            // field("Buy-from Type"; Rec."Buy-from Type")
            // {
            //     ApplicationArea = all;
            // }
            // field("Buy-from No."; Rec."Buy-from No.")
            // {
            //     ApplicationArea = all;
            // }
            // field(Name; Rec."Buy-from Name")
            // {
            //     ApplicationArea = all;
            // }
            // field("Ship-to Address Code"; Rec."Buy-from Address Code")
            // {
            //     Visible = false;
            //     ApplicationArea = all;
            // }
            // field(Address; Rec."Buy-from Address")
            // {
            //     Visible = false;
            //     ApplicationArea = all;
            // }
            // field("Phone No."; Rec."Buy-from Phone No.")
            // {
            //     Visible = false;
            //     ApplicationArea = all;
            // }
            // field(Contact; Rec."Buy-from Contact")
            // {
            //     Visible = false;
            //     ApplicationArea = all;
            // }
        }
        modify("Posting Date")
        {
            Visible = true;
        }

        addafter("No.")
        {
            field("Source No."; Rec."Source No.")
            {
                Caption = 'Source No.';
                ApplicationArea = all;
            }
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
        addafter("&Receipt")
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Batch Post")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Batch Post';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Text01: Label 'Will you confirm to post selected warehouse receipts';
                        WhseRcptHeader: Record "Warehouse Receipt Header";
                        WhseRcptLine: Record "Warehouse Receipt Line";
                        PONumber: Code[20];
                        WhsePostReceipt: Codeunit "Whse.-Post Receipt";
                    begin
                        If not Confirm(Text01, false) then
                            exit;
                        CurrPage.SetSelectionFilter(WhseRcptHeader);
                        //check
                        if WhseRcptHeader.FindFirst() then
                            repeat
                                //WhseRcptHeader.TestField("Prepared By");
                                WhseRcptLine.Reset();
                                WhseRcptLine.SetRange("No.", WhseRcptHeader."No.");
                                if WhseRcptLine.FindFirst() then
                                    repeat
                                        WhseRcptLine.TestField("Location Code");
                                        WhseRcptLine.TestField("Bin Code");
                                        WhseRcptLine.TestField("Qty. to Receive");
                                    until WhseRcptLine.Next() = 0;
                            until WhseRcptHeader.Next() = 0;
                        //post
                        if WhseRcptHeader.FindFirst() then
                            repeat
                                WhseRcptLine.Reset();
                                WhseRcptLine.SetRange("No.", WhseRcptHeader."No.");
                                if WhseRcptLine.FindFirst() then begin
                                    WhsePostReceipt.Run(WhseRcptLine);
                                    //WhsePostReceipt.GetResultMessage;
                                    Clear(WhsePostReceipt);
                                end;
                            until WhseRcptHeader.Next() = 0;
                    end;
                }
            }
        }
    }
    var
        // SourceNo: Code[20];
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        PurchaseLine: Record "Purchase Line";

    trigger OnAfterGetRecord()
    begin
        // WarehouseReceiptLine.Reset();
        // WarehouseReceiptLine.SetRange("No.", Rec."No.");
        // if WarehouseReceiptLine.FindFirst() then begin
        //     SourceNo := WarehouseReceiptLine."Source No.";
        // end else
        //     SourceNo := '';


        TotalQuantity := 0;
        TotalAmount2 := 0;
        if WarehouseReceiptLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseReceiptLine."Qty. to Receive";
                if PurchaseLine.get(PurchaseLine."Document Type"::Order, WarehouseReceiptLine."Source No.", WarehouseReceiptLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseReceiptLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                end;
            until WarehouseReceiptLine.Next() = 0;
    end;

    var
        TotalQuantity: Decimal;
        TotalAmount2: Decimal;
}
