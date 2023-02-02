pageextension 59149 "TP Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = all;
            }
        }
    }
}
