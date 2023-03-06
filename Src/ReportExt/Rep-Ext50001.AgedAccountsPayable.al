reportextension 50001 "Aged Accounts Payable Ext" extends "Aged Accounts Payable"
{
    dataset
    {
        add(TempVendortLedgEntryLoop)
        {
            column(VendorName2; Vendor."Name 2")
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
