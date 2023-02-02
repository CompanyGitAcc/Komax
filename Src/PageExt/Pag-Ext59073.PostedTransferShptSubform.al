pageextension 59073 "TP Posted Trans. Shpt. Subform" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
    }
}
