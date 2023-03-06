report 50053 "Sales History"
{
    WordLayout = './Layout/SalesHistory.docx';
    Caption = 'Sales History';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    WordMergeDataItem = "Sales Customer";

    dataset
    {
        dataitem("Sales Customer"; "Sales Shipment Line")
        {
            DataItemTableView = SORTING("Line No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";

            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
            }
            column(Sell_to_Customer_Name; CustomerName)
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Line_No_; "Line No.")
            {
            }
            column(Order_No_; "Order No.")
            {
            }
            column(No_; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Shipment_Date; "Shipment Date")
            {
            }
            column(OrderDate; OrderDate)
            {
            }
            column(OrderType; OrderType)
            {
            }

            trigger OnPreDataItem()
            begin
                SETRANGE(Type, "Sales Customer".Type::Item);
                //SETFILTER("No.",'<>%1','');
                SETFILTER(Quantity, '<>%1', 0);
            end;

            trigger OnAfterGetRecord()
            begin
                Grcd_ShipHeader.RESET;
                Grcd_ShipHeader.SETRANGE(Grcd_ShipHeader."No.", "Sales Customer"."Document No.");
                IF Grcd_ShipHeader.FIND('-') THEN BEGIN
                    CustomerName := Grcd_ShipHeader."Sell-to Customer Name 2";
                    PostingDate := Grcd_ShipHeader."Posting Date";
                    OrderDate := Grcd_ShipHeader."Order Date";
                    OrderType := Grcd_ShipHeader."Order Type";
                END
                ELSE BEGIN
                    CustomerName := '';
                    PostingDate := "Sales Customer"."Posting Date";
                    OrderDate := 0D;
                    Evaluate(OrderType, '');
                END;
            end;


        }
    }

    var
        Grcd_SalesHeader: Record "Sales Header";
        Grcd_ShipHeader: Record "Sales Shipment Header";
        OrderDate: Date;
        PostingDate: Date;
        CustomerName: Text[80];
        ExportToExcel: Boolean;
        TempExcelBuffer: Record "Excel Buffer";
        RowNo: Integer;
        OrderType: Enum "Sales Order Type";

}


