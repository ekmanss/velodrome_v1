pragma solidity 0.8.13;

import "./BaseTest.sol";

contract PairFeesTest is BaseTest {

    function setUp() public {
        deployOwners();
        deployCoins();
        mintStables();
        deployPairFactoryAndRouter();
        factory.setFee(true, 2); // 2 bps = 0.02%
        deployPairWithOwner(address(owner));
        mintPairFraxUsdcWithOwner(address(owner));
    }

    function testSwapAndClaimFees() public {
        Router.route[] memory routes = new Router.route[](1);
        routes[0] = Router.route(address(USDC), address(FRAX), true);

        assertEq(
            router.getAmountsOut(USDC_1, routes)[1],
            pair.getAmountOut(USDC_1, address(USDC))
        );

        uint256[] memory assertedOutput = router.getAmountsOut(USDC_1, routes);
        USDC.approve(address(router), USDC_1);
        router.swapExactTokensForTokens(
            USDC_1,
            assertedOutput[1],
            routes,
            address(owner),
            block.timestamp
        );
        vm.warp(block.timestamp + 1801);
        vm.roll(block.number + 1);
        address fees = pair.fees();
        assertEq(USDC.balanceOf(fees), 200); // 0.01% -> 0.02%
        uint256 b = USDC.balanceOf(address(owner));
        pair.claimFees();
        assertGt(USDC.balanceOf(address(owner)), b);
    }
}