pageextension 59134 "TP Prod. Order Line List" extends "Prod. Order Line List"
{
    layout
    {
        addlast(Control1)
        {
            field("Sorce Line No."; Rec."Sorce Line No.")
            {
                ApplicationArea = all;
            }
            field("Sorce No."; Rec."Sorce No.")
            {
                ApplicationArea = all;
            }

        }
    }

}
