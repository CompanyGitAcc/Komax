pageextension 59145 "TP Company Information" extends "Company Information"
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
        addlast(Shipping)
        {
            field("Customs Ship-to Address"; Rec."Customs Ship-to Address")
            {
                ApplicationArea = all;
            }
        }
    }

}
