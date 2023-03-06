pageextension 59113 "TP Item Lookup" extends "Item Lookup"
{
    layout
    {

        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
        }
    }
}
