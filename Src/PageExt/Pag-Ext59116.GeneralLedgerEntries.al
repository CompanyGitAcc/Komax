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
            field("Customer Entry Exist"; Rec."Customer Entry Exist")
            {
                ApplicationArea = all;
            }
        }
        addbefore(Amount)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
                Importance = Additional;
            }
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";

}
