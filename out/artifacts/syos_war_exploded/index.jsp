<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SYOS POS System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gradient-to-br from-indigo-600 to-blue-400 text-white font-sans min-h-screen flex items-center justify-center">
<div class="max-w-lg w-full bg-white bg-opacity-10 backdrop-blur-lg shadow-xl rounded-2xl p-10 border border-white border-opacity-20">
    <!-- POS System Title -->
    <div class="text-center mb-10">
        <h1 class="text-5xl font-extrabold text-white tracking-wide drop-shadow-lg">SYOS POS System</h1>
        <p class="mt-3 text-lg text-gray-200">Select an option to continue</p>
    </div>

    <!-- Menu Options -->
    <div class="grid gap-6">
        <a href="billing" class="flex items-center justify-between bg-white bg-opacity-20 hover:bg-opacity-30 text-white font-semibold py-5 px-6 text-xl rounded-xl shadow-lg transition duration-300 transform hover:scale-105 border border-white border-opacity-30">
            <span>💳 Billing System</span>
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
        </a>
        <a href="report" class="flex items-center justify-between bg-white bg-opacity-20 hover:bg-opacity-30 text-white font-semibold py-5 px-6 text-xl rounded-xl shadow-lg transition duration-300 transform hover:scale-105 border border-white border-opacity-30">
            <span>📊 Generate Report</span>
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
        </a>
        <a href="customer" class="flex items-center justify-between bg-white bg-opacity-20 hover:bg-opacity-30 text-white font-semibold py-5 px-6 text-xl rounded-xl shadow-lg transition duration-300 transform hover:scale-105 border border-white border-opacity-30">
            <span>👥 Customer Management</span>
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
        </a>
    </div>
</div>
</body>


</html>
