pageextension 59055 "TP Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
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
