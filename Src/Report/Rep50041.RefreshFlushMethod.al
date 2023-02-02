report 50041 "Refresh Flush Method"
{
    Caption = 'Refresh Flush Method';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            begin
                Window.Update(1, Item."No.");
                if Item."Flushing Method" = Item."Flushing Method"::Backward then begin
                    Item."ABC-Part" := 'C';
                    Item.Modify();
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('#1#########################');
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        Window: Dialog;
}
