pageextension 59056 "TP Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }

        }

    }
}
