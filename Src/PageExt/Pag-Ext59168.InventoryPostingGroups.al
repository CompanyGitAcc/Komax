pageextension 59168 "TP Inventory Posting Groups" extends "Inventory Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Setup Lines"; Rec."Setup Lines")
            {
                ApplicationArea = all;
            }
        }

    }



}
