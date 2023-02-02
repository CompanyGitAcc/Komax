pageextension 59128 "TP Requisition Lines" extends "Requisition Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Short Description"; Rec."Short Description")
            {
                ApplicationArea = all;
            }
        }
    }

}
