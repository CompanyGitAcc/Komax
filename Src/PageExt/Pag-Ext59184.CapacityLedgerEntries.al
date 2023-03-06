pageextension 59184 "TP Capacity Ledger Entries" extends "Capacity Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }


}
