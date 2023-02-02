pageextension 59139 "TP Reg. Whse. Activity List" extends "Registered Whse. Activity List"
{
    layout
    {
        addlast(Control1)
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
            }

        }
    }

}
