pageextension 59174 "TP Warehouse Put-aways" extends "Warehouse Put-aways"
{
    layout
    {
        modify("Source No.")
        {
            Visible = false;
        }
        addafter("Source Document")
        {
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = all;
            }
        }
    }



}
