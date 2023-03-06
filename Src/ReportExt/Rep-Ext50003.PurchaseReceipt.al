reportextension 50003 "Purchase - Receipt Ext" extends "Purchase - Receipt"
{
    dataset
    {
        add("Purch. Rcpt. Line")
        {
            column(ItemDescription; ItemDescription)
            {
            }
        }

        modify("Purch. Rcpt. Line")
        {
            trigger OnBeforeAfterGetRecord()
            begin
                if Item.get("Purch. Rcpt. Line"."No.") then
                    ItemDescription := Item.Description
                else
                    ItemDescription := '';
            end;
        }

    }
    requestpage
    {
        layout
        {

        }
    }
    var
        ItemDescription: Code[50];
        Item: Record Item;
}
