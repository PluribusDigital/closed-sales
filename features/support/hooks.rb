Before do
  loan_data = [
    {"sale_id":"93F11",   "site_name":"Dallas Field Branch","date_sold":"1994-01-31","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":42, "book_value":14045364,"sales_price":11343972,"winning_bidder":"Army National Bank","address":"300 Kansas Ft. Leavenworth, KS 66027"},
    {"sale_id":"93D23",   "site_name":"Dallas Field Branch","date_sold":"1994-02-22","loan_type":"RE\\Commercial", "quality":"Non-Performing","number_of_loans":2,  "book_value":20111573,"sales_price":425058,"winning_bidder":"KCL Pacific Corporation","address":"136 East South Temple Salt Lake City, UT 84111"},
    {"sale_id":"93D24",   "site_name":"Dallas Field Branch","date_sold":"1994-02-23","loan_type":"Other",          "quality":"Performing",    "number_of_loans":11, "book_value":7645832, "sales_price":6773878,"winning_bidder":"Bank Midwest, NA","address":"1111 Main St, Suite 1600 Kansas City, MO 64105"},
    {"sale_id":"93F06.1", "site_name":"Dallas Field Branch","date_sold":"1994-03-15","loan_type":"RE\\Commercial", "quality":"Non-Performing","number_of_loans":16, "book_value":2224355, "sales_price":277057,"winning_bidder":"Southwest Federated-Dallas","address":"7502 Greenville Ave. Suite 500 Dallas, TX 75231"},
    {"sale_id":"93F06.2", "site_name":"Dallas Field Branch","date_sold":"1994-03-15","loan_type":"RE\\Commercial", "quality":"Non-Performing","number_of_loans":11, "book_value":1002701, "sales_price":151607,"winning_bidder":"Southwest Federated-Dallas","address":"7502 Greenville Ave. Suite 500 Dallas, TX 75231"},
    {"sale_id":"93F06.4", "site_name":"Dallas Field Branch","date_sold":"1994-03-25","loan_type":"Other",          "quality":"Non-Performing","number_of_loans":8,  "book_value":605138,  "sales_price":134887,"winning_bidder":"Southwest Federated-Dallas","address":"7502 Greenville Ave. Suite 500 Dallas, TX 75231"},
    {"sale_id":"93AM05.1","site_name":"Dallas Field Branch","date_sold":"1994-03-29","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":1023624, "sales_price":1011766,"winning_bidder":"West Loop S&LA","address":"1980 Post Oak Blvd. Suite 500 Houston, TX 77056"},
    {"sale_id":"94LG021", "site_name":"Dallas Field Branch","date_sold":"1994-03-31","loan_type":"Bank Charge Off","quality":"Non-Performing","number_of_loans":459,"book_value":2630540, "sales_price":97593,"winning_bidder":"National Collection Services,","address":"1340 12th Ave. Longview, WA 98632"},
    {"sale_id":"93C13.1", "site_name":"Dallas Field Branch","date_sold":"1994-04-01","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":4562725, "sales_price":3456244,"winning_bidder":"Bank Midwest","address":"1100 Main St, Suite 350 Kansas City, MO 64105"},
    {"sale_id":"93AM05.2","site_name":"Dallas Field Branch","date_sold":"1994-04-06","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":1873541, "sales_price":1517750,"winning_bidder":"Fidelity Bank, N.A.","address":"6821 Preston Road Dallas, TX 75205"},
    {"sale_id":"94CM12.2","site_name":"Dallas Field Branch","date_sold":"1994-04-07","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":989419,  "sales_price":608604,"winning_bidder":"NAB Asset Venture III","address":"5851 San Felipe, Suite 300 Houston, TX 77057"},
    {"sale_id":"94CM12.1","site_name":"Dallas Field Branch","date_sold":"1994-04-08","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":2,  "book_value":665566,  "sales_price":245421,"winning_bidder":"Beal Bank","address":"15770 N. Dallas Parkway, Suite Dallas, TX 78209"},
    {"sale_id":"94LJ01.8","site_name":"Dallas Field Branch","date_sold":"1994-04-13","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":1549987, "sales_price":1276845,"winning_bidder":"West Loop S&LA","address":"1980 Post Oak Blvd, Suite 900 Houston, TX 77056-3808"},
    {"sale_id":"94LS01",  "site_name":"Dallas Field Branch","date_sold":"1994-04-14","loan_type":"Other",          "quality":"Non-Performing","number_of_loans":211,"book_value":2568244, "sales_price":826975,"winning_bidder":"Commercial Financial/SPC Acqui","address":"7130 South Lewis, Suite 300 Tulsa, OK 74136"},
    {"sale_id":"94CM15",  "site_name":"Dallas Field Branch","date_sold":"1994-04-19","loan_type":"RE\\Commercial", "quality":"Non-Performing","number_of_loans":1,  "book_value":11785247,"sales_price":1602793,"winning_bidder":"Paul W. Hoover, Jr.","address":"111 Center St., 11th Floor Little Rock, AR 72201"},
    {"sale_id":"94LJ01.2","site_name":"Dallas Field Branch","date_sold":"1994-04-19","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":1224297, "sales_price":768859,"winning_bidder":"NAB Asset Venture III","address":"5851 San Felipe, Suite 300 Houston, TX 77057"},
    {"sale_id":"94LJ01.3","site_name":"Dallas Field Branch","date_sold":"1994-04-19","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":111129,  "sales_price":62226,"winning_bidder":"NAB Asset Venture III","address":"5851 San Felipe, Suite 300 Houston, TX 77057"},
    {"sale_id":"94LJ01.4","site_name":"Dallas Field Branch","date_sold":"1994-04-19","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":111129,  "sales_price":85230,"winning_bidder":"Dynamic Real Estate Co.","address":"13750 San Pedro, Suite 350 San Antonio, TX 78232"},
    {"sale_id":"94LJ01.5","site_name":"Dallas Field Branch","date_sold":"1994-04-28","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":1257702, "sales_price":1175281,"winning_bidder":"Bank Midwest, NA","address":"1111 Main St, Suite 1600 Kansas City, MO 64105"},
    {"sale_id":"94LJ02.5","site_name":"Dallas Field Branch","date_sold":"1994-04-28","loan_type":"RE\\Commercial", "quality":"Performing",    "number_of_loans":1,  "book_value":2054004, "sales_price":1897079,"winning_bidder":"Bank Midwest, NA","address":"1111 Main St, Suite 1600 Kansas City, MO 64105"}
  ]
  loan_data.each do |l|
    Loan.create(l)
  end
end

AfterStep('@pause') do
  print "Press Return to continue"
  STDIN.getc
end

AfterStep('@slow') do
  sleep 2 #seconds
end