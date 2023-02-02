pageextension 59127 "TP Units of Measure" extends "Units of Measure"
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
