pageextension 59059 "TP Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = all;
            }
        }

    }
}
