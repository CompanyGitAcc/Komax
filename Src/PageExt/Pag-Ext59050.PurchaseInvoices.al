pageextension 59050 "TP Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        modify(Status)
        {
            Visible = true;
        }
        moveafter("Location Code"; Status)

    }
}
