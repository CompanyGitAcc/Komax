pageextension 59070 "TP Transfer Order Subform" extends "Transfer Order Subform"
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
