pageextension 59132 "TP Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        addlast(Control1)
        {
            field("Unit of Measure Exist"; Rec."Unit of Measure Exist")
            {
                ApplicationArea = all;
            }
            field("Base Unit of Measure Exist"; Rec."Base Unit of Measure Exist")
            {
                ApplicationArea = all;
            }

        }
    }

}
