pageextension 59126 "TP Purchase Receipt Statistics" extends "Purchase Receipt Statistics"
{
    layout
    {
        addlast(General)
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }

        }
    }

}
