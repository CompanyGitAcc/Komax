reportextension 50002 "Aged Accounts Receivable Ext" extends "Aged Accounts Receivable"
{
    dataset
    {
        add(TempCustLedgEntryLoop)
        {
            column(CustomerName2; Customer."Name 2")
            {
            }
        }

    }
    requestpage
    {
        layout
        {

        }
    }
}
