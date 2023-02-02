tableextension 59104 "MP Item Vendor" extends "Item Vendor"
{
    fields
    {
        field(50000; "Blanket Order Quantity"; Decimal)
        {
            Caption = 'Blanket Order Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("Buy-from Vendor No." = field("Vendor No."), "No." = field("Item No."), "Document Type" = const("Blanket Order")));
        }
        field(50001; "Blanket Order Outstanding Qty."; Decimal)
        {
            Caption = 'Blanket Order Outstanding Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Buy-from Vendor No." = field("Vendor No."), "No." = field("Item No."), "Document Type" = const("Blanket Order")));
        }
        field(50002; "Safety Qty."; Decimal)
        {
            Caption = 'Safety Qty.';
        }
    }

}
