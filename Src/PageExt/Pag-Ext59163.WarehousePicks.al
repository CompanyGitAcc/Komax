pageextension 59163 "TP Warehouse Picks" extends "Warehouse Picks"
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
