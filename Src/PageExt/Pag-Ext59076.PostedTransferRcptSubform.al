pageextension 59076 "TP Posted Trans. Rcpt. Subform" extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        //++YK004-HH220101

        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
    }
}
