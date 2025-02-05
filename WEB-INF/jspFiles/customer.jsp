<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Customer Management</title>
            <script src="https://cdn.tailwindcss.com"></script>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

            <script>
                $(document).ready(function () {
                    function attachEventListeners() {
                        console.log("Attaching event listeners...");

                        // Handle add customer button click
                        $("#addCustomerBtn").on("click", function () {
                            console.log("Add Customer button clicked");
                            // Set form for adding a new customer
                            $("#customerAction").val("2");  // Set action for add
                            $("#customerId").val('');
                            $("#customerName").val('');
                            $("#customerEmail").val('');
                            $("#customerPhone").val('');
                            $("#customerLoyaltyPoints").val('');
                            $("#loyaltyPointsField").hide();  // Hide loyalty points for add
                            $("#customerPopup").show();  // Show the popup
                        });

                        // Use event delegation to handle edit button clicks
                        $("#customerTableBody").on("click", ".editCustomerBtn", function () {
                            console.log("Edit button clicked");
                            var customerData = $(this).data("customer");
                            if (customerData) {
                                // Populate fields for editing
                                $("#customerAction").val("3");  // Set action for edit
                                $("#customerId").val(customerData.id);
                                $("#customerName").val(customerData.name);
                                $("#customerEmail").val(customerData.email);
                                $("#customerPhone").val(customerData.phoneNumber);
                                $("#customerLoyaltyPoints").val(customerData.loyaltyPoints);
                                $("#version").val(customerData.version);
                                $("#loyaltyPointsField").show();
                            }
                            $("#customerPopup").show();
                        });

                        // Use event delegation to handle delete button clicks
                        $("#customerTableBody").on("click", ".deleteCustomerBtn", function () {
                            console.log("Delete button clicked");
                            var customerId = $(this).data("customerid"); // Ensure correct casing
                            console.log("Customer ID to delete: " + customerId); // Debugging log

                            Swal.fire({
                                title: "Are you sure?",
                                text: "This action will permanently delete the customer.",
                                icon: "warning",
                                showCancelButton: true,
                                confirmButtonColor: "#d33",
                                cancelButtonColor: "#3085d6",
                                confirmButtonText: "Yes, Delete!",
                                cancelButtonText: "Cancel"
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    $.post("customer", {
                                        action: "3",
                                        customerAction: "4",
                                        customerId: customerId
                                    }, function (data) {
                                        Swal.fire({
                                            title: "Deleted!",
                                            text: "The customer has been deleted successfully.",
                                            icon: "success",
                                            confirmButtonColor: "#3085d6"
                                        }).then(() => {
                                            location.reload();
                                        });
                                    });
                                }
                            });

                        });

                        // Hide the popup
                        $("#closePopup, #cancelBtn").on("click", function () {
                            $("#customerPopup").hide();
                        });
                    }

                    // Attach initial event listeners
                    attachEventListeners();

                    // Search customer by phone number
                    $("#searchCustomerBtn").on("click", function () {
                        var phoneNumber = $("#searchPhoneNumber").val();
                        $.get("customer?action=search&customerPhone=" + phoneNumber, function (data) {
                            console.log("Search completed, updating table...");
                            $("#customerTableBody").html($(data).find("#customerTableBody").html()); // Replace only the table body content
                            attachEventListeners(); // Reattach event listeners after search
                        });
                    });

                    // Clear search and reload all customers
                    $("#clearSearchBtn").on("click", function () {
                        $("#searchPhoneNumber").val(''); // Clear the search input
                        $.get("customer", function (data) {
                            console.log("Cleared search, reloading table...");
                            $("#customerTableBody").html($(data).find("#customerTableBody").html()); // Reload all customers
                            attachEventListeners(); // Reattach event listeners after clearing search
                        });
                    });
                });

            </script>
        </head>

        <body class="bg-gradient-to-br from-indigo-600 to-blue-400 text-white font-sans min-h-screen">
        <div class="max-w-5xl mx-auto p-10 bg-white bg-opacity-10 backdrop-blur-lg shadow-xl rounded-2xl border border-white border-opacity-20">
        <div class="flex items-center space-x-3 mb-6">
            <a href="<c:url value='/' />"
               class="bg-white bg-opacity-20 text-white hover:bg-white hover:text-indigo-600 font-semibold py-3 px-6 rounded-full shadow-md transition duration-300 inline-flex items-center">
                <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                     xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Return to Main Menu
            </a>


        </div>

            <h2 class="text-3xl font-bold text-gray-900 mb-6">
            <svg class="w-8 h-8 mr-3 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                         xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a4 4 0 00-8 0v2M5 21h14M9 17h6M9 12h6"></path>
                    </svg>
                    Customer Management
                </h2>


                <!-- Display error messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg shadow-md mb-4">
                    <svg class="w-6 h-6 mr-2 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                             xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                        <p class="text-lg">${errorMessage}</p>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg shadow-md mb-4">
                    <svg class="w-6 h-6 mr-2 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                             xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        <p class="text-lg">${successMessage}</p>
                    </div>
                </c:if>


                <div class="bg-white p-6 rounded-lg shadow-lg flex items-center justify-between mb-6">
                    <button id="addCustomerBtn"
                            class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105 flex items-center">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                             xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                        </svg>
                        Add Customer
                    </button>

                    <div class="flex space-x-3">
                        <input type="text" id="searchPhoneNumber" placeholder="Enter Phone Number"
                               class="border border-gray-300 rounded-lg py-3 px-4 shadow-md focus:ring-2 focus:ring-indigo-500 text-lg w-64 text-black bg-white bg-opacity-80 placeholder-gray-700">

                        <button id="searchCustomerBtn"
                                class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg shadow-md transition duration-300">
                            Search
                        </button>
                        <button id="clearSearchBtn"
                                class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-3 px-6 rounded-lg shadow-md transition duration-300">
                            Clear Search
                        </button>
                    </div>
                </div>





                    <div class="overflow-x-auto">
                        <!-- Modern Customer Table -->
                        <div class="bg-white bg-opacity-90 p-6 rounded-lg shadow-lg border border-gray-300 backdrop-blur-md">
                        <h3 class="text-2xl font-semibold mb-4 flex items-center text-gray-900">
                                <svg class="w-6 h-6 text-indigo-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                     xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M9 11l3 3L22 4"></path>
                                </svg>
                                Customer List
                            </h3>

                            <table id="customerTable" class="min-w-full bg-white rounded-xl shadow-xl border border-gray-300">
                                <thead class="bg-indigo-700 text-white text-lg">

                                <tr>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">ID</th>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">Name</th>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">Email</th>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">Phone Number</th>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">Loyalty Points</th>
                                    <th class="px-6 py-3 text-left text-sm font-semibold">Actions</th>
                                </tr>
                                </thead>
                                <tbody id="customerTableBody" class="bg-gray-50 divide-y divide-gray-300 text-black">
                                <c:forEach var="customer" items="${customers}">
                                    <tr class="hover:bg-gray-200 transition duration-300 text-black">
                                    <td class="px-6 py-4 text-black">${customer.id}</td>
                                        <td class="px-6 py-4 text-black">${customer.name}</td>
                                        <td class="px-6 py-4 text-black">${customer.email}</td>
                                        <td class="px-6 py-4 text-black">${customer.phoneNumber}</td>
                                        <td class="px-6 py-4 font-semibold text-indigo-600">${customer.loyaltyPoints}</td>

                                        <td class="px-6 py-4 flex space-x-2">
                                            <button class="bg-yellow-500 hover:bg-yellow-600 text-white py-2 px-4 rounded-lg shadow flex items-center editCustomerBtn"
                                                    data-customer='{"id":"${customer.id}", "name":"${customer.name}", "email":"${customer.email}", "phoneNumber":"${customer.phoneNumber}", "loyaltyPoints":"${customer.loyaltyPoints}", "version":"${customer.version}"}'>
                                                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                                     xmlns="http://www.w3.org/2000/svg">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M12 4v16m8-8H4"></path>
                                                </svg>
                                                Edit
                                            </button>
                                            <button class="bg-red-500 hover:bg-red-600 text-white py-2 px-4 rounded-lg shadow flex items-center deleteCustomerBtn"
                                                    data-customerId="${customer.id}">
                                                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                                     xmlns="http://www.w3.org/2000/svg">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                          d="M6 18L18 6M6 6l12 12"></path>
                                                </svg>
                                                Delete
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${customers == null || customers.isEmpty()}">
                                    <tr>
                                        <td colspan="6" class="px-6 py-4 text-center text-gray-500">No customers found.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>


                <!-- Customer Add/Edit Popup -->
        <div id="customerPopup"
             class="fixed inset-0 bg-white bg-opacity-20 backdrop-blur-md flex items-center justify-center z-50"
             style="display:none;">


        <div class="bg-white p-6 rounded-lg shadow-lg max-w-lg w-full">
                        <form action="customer" method="post">
                            <input type="hidden" name="action" value="3">
                            <input type="hidden" name="customerAction" id="customerAction" value="2">
                            <input type="hidden" name="customerId" id="customerId">
                            <input type="hidden" name="version" id="version">

                            <h3 class="text-xl font-semibold mb-4">Customer Information</h3>
                            <div class="mb-4">
                                <label for="customerName" class="block text-sm font-medium text-gray-700">Name</label>
                                <input type="text" name="customerName" id="customerName"
                                       class="border border-gray-300 rounded-lg py-2 px-4 w-full shadow-sm focus:ring focus:ring-indigo-500 text-black bg-white bg-opacity-80 placeholder-gray-700"
                                       required>
                            </div>

                            <div class="mb-4">
                                <label for="customerEmail" class="block text-sm font-medium text-gray-700">Email</label>
                                <input type="email" name="customerEmail" id="customerEmail"
                                       class="border border-gray-300 rounded-lg py-3 px-4 w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 text-black bg-white bg-opacity-80 placeholder-gray-700"

                                       required>
                            </div>

                            <div class="mb-4">
                                <label for="customerPhone" class="block text-sm font-medium text-gray-700">Phone
                                    Number</label>
                                <input type="text" name="customerPhone" id="customerPhone"
                                       class="border border-gray-300 rounded-lg py-3 px-4 w-full shadow-sm focus:ring-indigo-500 focus:border-indigo-500 text-black bg-white bg-opacity-80 placeholder-gray-700"

                                       required>
                            </div>

                            <div id="loyaltyPointsField" class="mb-4" style="display:none;">
                                <label for="customerLoyaltyPoints"
                                    class="block text-sm font-medium text-gray-700">Loyalty Points</label>
                                <input type="number" name="customerLoyaltyPoints" id="customerLoyaltyPoints"
                                    class="border border-gray-300 rounded-lg py-2 px-4 w-full shadow-sm">
                            </div>

                            <div class="flex justify-end space-x-4">
                                <input type="submit" value="Save"
                                    class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow">
                                <button type="button" id="cancelBtn"
                                    class="bg-gray-500 hover:bg-gray-600 text-white font-semibold py-2 px-6 rounded-lg shadow">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>