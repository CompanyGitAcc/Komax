pageextension 59112 "TP Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
