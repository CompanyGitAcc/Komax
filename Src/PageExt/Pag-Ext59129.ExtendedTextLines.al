pageextension 59129 "TP Extended Text Lines" extends "Extended Text Lines"
{
    layout
    {
        addlast(Control1)
        {
            field(Sheet; Rec.Sheet)
            {
                ApplicationArea = all;
            }
            field(Index; Rec.Index)
            {
                ApplicationArea = all;
            }
            field("Apply To Order"; Rec."Apply To Order")
            {
                ApplicationArea = all;
            }
        }
    }

}
