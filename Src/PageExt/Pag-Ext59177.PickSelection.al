pageextension 59177 "TP Pick Selection" extends "Pick Selection"
{
    layout
    {
        addbefore("Document No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
            }
        }
    }


}
