reportextension 50000 "Calc. Plan - Plan. Wksh. Ext" extends "Calculate Plan - Plan. Wksh."
{
    dataset
    {
        modify(Item)
        {
            trigger OnAfterPreDataItem()
            begin
                if CustomsSupervision then
                    Item.SetRange("Customs Supervision", true)
                else
                    item.SetRange("Customs Supervision", false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            addafter(MRP)
            {
                field(CustomsSupervision; CustomsSupervision)
                {
                    Caption = 'Customs Supervision';
                }
            }
        }
    }
    var
        CustomsSupervision: Boolean;
}
