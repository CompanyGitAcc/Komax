pageextension 59183 "TP Purchase Lines" extends "Purchase Lines"
{
    layout
    {
        addafter("Line Amount")
        {
            field("OC Date"; Rec."OC Date")
            {
                ApplicationArea = all;
            }
        }
    }


}
