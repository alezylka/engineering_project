function dydt = model_brak_skl_zapas(t, y, ATPi, ATPgli, maxGli, metabolizm, dieta, b1, b2, b3, c1, c2, c3)
    ATP = y(1);
    Gli = y(2);
    I = y(3);
    E = y(4);
    C16 = y(5);

    var = maxGli > Gli;
    var2 = Gli > 0;
    var3 = ATP < ATPgli;

    dATPdt = -metabolizm + dieta - (E / I) * var * ATP + (I / E) * (Gli * (38/180));
    dglikogendt = (((E / I) * var * ATP * 180) / 38) - (I / E) * var2 * Gli;
    dIdt = b1 * (ATP - ATPi) - b2 * I + b3;
    dEdt = -c1 * (ATP - ATPgli) * var3 - c2 * E + c3;
    dC16dt = 0.01 * ((ATP * (E/I) * var * dIdt / 129) - 0.01 * C16 * (I / E));

    dydt = [dATPdt; dglikogendt; dIdt; dEdt; dC16dt];
end
