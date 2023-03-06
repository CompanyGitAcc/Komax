pageextension 59169 "TP Gen. Product Posting Groups" extends "Gen. Product Posting Groups"
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
