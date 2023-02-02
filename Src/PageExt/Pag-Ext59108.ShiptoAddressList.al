pageextension 59108 "TP Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        //++YK021-HH220507
        modify(Address)
        {
            Visible = true;
        }
        modify(Contact)
        {
            Visible = true;
        }
        modify("Phone No.")
        {
            Visible = true;
        }
        //--YK021
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = all;
            }
        }
    }
}
