pageextension 59143 "TP Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Machine No."; Rec."Machine No.")
            {
                ApplicationArea = all;
            }
        }
    }



}
