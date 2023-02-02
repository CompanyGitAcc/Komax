report 50039 "Warehouse Receipt"
{
    WordLayout = './Layout/WarehouseReceipt.docx';
    Caption = 'Warehouse Receipt';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Warehouse Receipt Header"; "Warehouse Receipt Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(No_WhseRcptHeader; "No.")
            {
            }
            //++Harvey
            column(DocDate_PurchHeader; Format("Posting Date", 0, '<Year4>-<Month,2>-<Day,2>'))
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(CompanyInfoCity; CompanyInfo.City)
            {
            }
            column(CompanyInfoPostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfoPhone_No; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoFax_No; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(Pay_to_Name; PaytoName)
            {
            }
            column(Pay_to_Address; PaytoAddress)
            {
            }
            column(Pay_to_City; PaytoCity)
            {
            }
            column(Pay_to_Post_Code; PaytoPostCode)
            {
            }
            column(Buy_from_No_; BFNo)
            {
            }
            column(Buy_from_Vendor_Name; BuyfromVendorName)
            {
            }
            column(Buy_from_Address; BuyfromAddress)
            {
            }
            column(BuyfromContactNo; BuyfromContactNo)
            {
            }
            column(BuyFromContactFaxNo; BuyFromContact."Fax No.")
            {
            }
            column(BuyFromContactPhoneNo; BuyFromContact."Phone No.")
            {
            }
            column(Ship_to_Name; ShiptoName)
            {
            }
            column(Ship_to_Address; ShiptoAddress)
            {
            }
            column(CustomShiptoAddr; CustomShiptoAddr)
            {
            }
            column(Ship_to_City; ShiptoCity)
            {
            }
            column(Ship_to_Post_Code; ShiptoPostCode)
            {
            }
            column(YourReference; YourReference)
            {
            }
            column(ourReference; ourReference)
            {
            }
            column(Source_No_; "Source No.")
            {
            }
            column(BuyFromType; BuyFromType)
            {
            }
            //--Harvey
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(AssignedUserID_WhseRcptHeader; "Warehouse Receipt Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_WhseRcptHeader; "Warehouse Receipt Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(No1_WhseRcptHeader; "Warehouse Receipt Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Show1; not Location."Bin Mandatory")
                {
                }
                column(Show2; Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehouseReceiptCaption; WarehouseReceiptCaptionLbl)
                {
                }
                dataitem("Warehouse Receipt Line"; "Warehouse Receipt Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Receipt Header";
                    DataItemTableView = SORTING("No.", "Line No.");
                    column(ShelfNo_WhseRcptLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_WhseRcptLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_WhseRcptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitofMeasureCode_WhseRcptLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_WhseRcptLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_WhseRcptLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_WhseRcptLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDocument_WhseRcptLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_WhseRcptLine; "Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseRcptLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    //++Harvey
                    column(ItemDescription; ItemDescription)
                    {
                    }
                    column(ItemReferenceDescription; ItemReferenceDescription)
                    {
                    }
                    column(ItemReferenceDescription2; ItemReferenceDescription2)
                    {
                    }
                    column(ItemReferenceNo; ItemReferenceNo)
                    {
                    }
                    column(Qty__to_Receive; "Qty. to Receive")
                    {
                    }
                    column(Qty__to_Cross_Dock; "Qty. to Cross-Dock")
                    {
                    }
                    //--Harvey

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");

                        if Item.get("Item No.") then begin
                            ItemDescription := item.Description;
                        end else
                            ItemDescription := '';

                        ItemReference.Reset();
                        ItemReference.SetRange("Item No.", "Item No.");
                        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Vendor);
                        ItemReference.SetRange("Reference Type No.", BFNo);
                        if ItemReference.FindFirst() then begin
                            ItemReferenceDescription := ItemReference.Description;
                            ItemReferenceDescription2 := ItemReference."Description 2";
                            ItemReferenceNo := ItemReference."Reference No.";
                        end else begin
                            ItemReferenceDescription := '';
                            ItemReferenceDescription2 := '';
                            ItemReferenceNo := '';
                        end;

                        if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, "Warehouse Receipt Line"."Source No.") then begin
                            PaytoName := PurchaseHeader."Pay-to Name 2";
                            PaytoAddress := PurchaseHeader."Pay-to Address 2";
                            PaytoCity := PurchaseHeader."Pay-to City";
                            PaytoPostCode := PurchaseHeader."Pay-to Post Code";
                            BuyfromVendorName := PurchaseHeader."Buy-from Vendor Name 2";
                            BuyfromAddress := PurchaseHeader."Buy-from Address 2";
                            BuyfromContactNo := PurchaseHeader."Buy-from Contact No.";
                            ShiptoName := PurchaseHeader."Ship-to Name";
                            ShiptoAddress := PurchaseHeader."Ship-to Address 2";
                            ShiptoCity := PurchaseHeader."Ship-to City";
                            ShiptoPostCode := PurchaseHeader."Ship-to Post Code";
                            YourReference := PurchaseHeader."Your Reference";
                            if SalesPurchPerson.get(PurchaseHeader."Purchaser Code") then
                                OurReference := SalesPurchPerson.Name;

                            if BuyFromContact.Get(PurchaseHeader."Buy-from Contact No.") then;

                            if PurchaseHeader."Customs Supervision" = true then begin
                                CustomShiptoAddr := CompanyInfo."Customs Ship-to Address";
                            end else begin
                                CustomShiptoAddr := PurchaseHeader."Ship-to Address 2";
                            end;

                            if "Source Document" = "Warehouse Receipt Line"."Source Document"::"Purchase Order" then begin
                                BuyFromType := '供应商编号';
                                if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, "Source No.") then begin
                                    BFNo := PurchaseHeader."Buy-from Vendor No.";
                                end;
                            end else begin
                                BuyFromType := '客户编号';
                                if SalesHeader.get(SalesHeader."Document Type"::Order, "Source No.") then begin
                                    BFNo := SalesHeader."Sell-to Customer No.";
                                end;
                            end;

                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Posted Receipt';

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
    end;

    var
        Location: Record Location;
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehouseReceiptCaptionLbl: Label 'Warehouse - Receipt';
        CompanyInfo: Record "Company Information";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        BuyFromContact: Record Contact;
        PaytoName: Text[100];
        PaytoAddress: Text[100];
        PaytoCity: Text[50];
        PaytoPostCode: Code[20];
        BuyfromVendorName: Text[100];
        BuyfromAddress: Text[100];
        BuyfromContactNo: Code[20];
        ShiptoName: Text[100];
        ShiptoAddress: Text[100];
        ShiptoCity: Text[50];
        ShiptoPostCode: Code[20];
        YourReference: Text[50];
        OurReference: Text[50];
        SalesPurchPerson: Record "Salesperson/Purchaser";
        ItemDescription: text[100];
        Item: Record Item;
        ItemReference: Record "Item Reference";
        ItemReferenceDescription: Text[100];
        ItemReferenceDescription2: Text[100];
        ItemReferenceNo: Code[20];
        BuyFromType: Text[10];
        CustomShiptoAddr: Text[100];
        BFNo: Code[20];
        BFType: Code[20];

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}


