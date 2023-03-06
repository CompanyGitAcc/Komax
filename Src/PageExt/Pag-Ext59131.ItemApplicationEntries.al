pageextension 59131 "TP Item Application Entries" extends "Item Application Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Exist Ledger Entry"; Rec."Exist Ledger Entry")
            {
                ApplicationArea = all;
            }

        }
    }

}
