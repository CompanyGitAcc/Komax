pageextension 59109 "TP Order Address List" extends "Order Address List"
{
    layout
    {
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
    }
}
