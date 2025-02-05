<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Report</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const reportChoice = document.getElementById('reportChoice');
            const dateField = document.getElementById('dateField');
            const dateLabel = document.getElementById('dateLabel');

            // Function to toggle the date field visibility and label based on selected report
            function toggleDateField() {
                const selectedValue = reportChoice.value;
                // Show date field for Daily Sales (1), Reshelved Items (2), and Bill Report (5)
                if (selectedValue === '1' || selectedValue === '2' || selectedValue === '5') {
                    dateField.style.display = 'block';
                    if (selectedValue === '5') {
                        dateLabel.innerHTML = 'Select Date (Optional)';
                    } else {
                        dateLabel.innerHTML = 'Select Date';
                    }
                } else {
                    dateField.style.display = 'none';
                }
            }

            // Initial call to set the visibility based on the default selection
            toggleDateField();

            // Event listener to check for changes in the dropdown
            reportChoice.addEventListener('change', toggleDateField);
        });
    </script>
</head>

<body class="bg-gradient-to-br from-indigo-600 to-blue-400 text-white font-sans min-h-screen flex items-center justify-center">
<div class="max-w-4xl w-full bg-white bg-opacity-10 backdrop-blur-lg shadow-xl rounded-2xl p-10 border border-white border-opacity-20">

    <!-- Back to Main Menu link with arrow -->
    <a href="<c:url value='/' />"
       class="bg-white bg-opacity-30 text-white hover:bg-indigo-600 hover:text-white font-semibold py-3 px-6 rounded-full shadow-lg transition duration-300 inline-flex items-center space-x-2 border border-white border-opacity-50 backdrop-blur-md mb-8">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"
             xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M15 19l-7-7 7-7"></path>
        </svg>
        <span>Return to Main Menu</span>
    </a>

    <h2 class="text-3xl font-bold text-gray-900 mb-6">Report Generation</h2>

    <!-- Form for selecting the report -->
    <form action="report" method="post" class="bg-white bg-opacity-80 shadow-md rounded-lg p-6 mb-8">
        <!-- Hidden action parameter -->
        <input type="hidden" name="action" value="2">

        <div class="grid grid-cols-2 gap-6">
            <!-- Report Type -->
            <div>
                <label for="reportChoice" class="block text-lg font-semibold text-gray-700 flex items-center">
                    📑 Select Report Type
                </label>
                <select name="reportChoice" id="reportChoice"
                        class="mt-2 block w-full p-3 border border-gray-300 rounded-lg shadow-md focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700">
                    <option value="1">📊 Daily Sales Report</option>
                    <option value="2">📦 Reshelved Items Report</option>
                    <option value="3">📉 Reorder Stock Report</option>
                    <option value="4">📋 Stock Report</option>
                    <option value="5">🧾 Bill Report</option>
                </select>
            </div>

            <!-- Date Field -->
            <div id="dateField">
                <label for="reportDate" id="dateLabel"
                       class="block text-lg font-semibold text-gray-700 flex items-center">
                    📅 Select Date
                </label>
                <input type="date" name="reportDate" id="reportDate"
                       class="mt-2 block w-full p-3 border border-gray-300 rounded-lg shadow-md focus:ring-indigo-500 focus:border-indigo-500 text-lg text-black caret-black bg-white bg-opacity-80 placeholder-gray-700">
            </div>
        </div>

        <div class="flex justify-center mt-6">
            <button type="submit" id="generateReportBtn"
                    class="bg-indigo-600 hover:bg-indigo-800 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-300 transform hover:scale-105 flex items-center">
                📄 Generate Report
            </button>
        </div>
    </form>

    <!-- Display the generated report -->
    <c:if test="${not empty reportData}">
        <div class="bg-white p-6 rounded-lg shadow-lg mt-6">
            <h3 class="text-2xl font-semibold mb-4 flex items-center text-gray-900">
                <svg class="w-6 h-6 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                     xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M9 12l2 2 4-4m0 4h4m-4-4h4m0 4h4"></path>
                </svg>
                Generated Report
            </h3>
            <div class="overflow-x-auto bg-gray-50 p-4 rounded-lg shadow-md border border-gray-300">
                <pre class="text-lg text-gray-900 whitespace-pre">${reportData}</pre>
            </div>
        </div>
    </c:if>
</div>
</body>

</html>
