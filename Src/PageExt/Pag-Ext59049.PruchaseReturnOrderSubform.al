pageextension 59049 "TP Purch. Return Order Subform" extends "Purchase Return Order Subform"
{
    layout
    {
        //++YK004-HH220101
        addafter("Location Code")
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }
        }

    }
}
