pageextension 59155 "TP Put-away Worksheet" extends "Put-away Worksheet"
{
    layout
    {
        addafter(Description)
        {
            field("To Bin Code"; Rec."To Bin Code")
            {
                ApplicationArea = all;
            }
            field("To Zone Code"; Rec."To Zone Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
