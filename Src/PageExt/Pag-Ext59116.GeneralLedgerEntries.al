pageextension 59116 "TP General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(Any; Rec.Any)
            {
                ApplicationArea = all;
            }
            field("Value Entry Exist"; Rec."Value Entry Exist")
            {
                ApplicationArea = all;
            }
        }
    }

}
